modulejs.define('components/log_spreadsheet_export', [], function () {
  var EXPORT_PATH = '/export_log_spreadsheet';
  var STATUS_POLLING_INTERVAL = 2500;

  var LogSpreadsheetExport = React.createClass({
    getInitialState: function () {
      return {
        exportStarted: false,
        exportFinished: false,
        statusPath: '',
        filePath: '',
        currentStatus: '',
        statusPollingIntervalId: null,
        allPossibleColumns: false
      }
    },

    componentWillUnmount: function () {
      this.stopPolling();
    },

    startExport: function () {
      this.setState({
        exportStarted: true,
        currentStatus: 'requested',
        currentStatusMsg: 'Export requested.'
      });
      $.ajax({
        type: 'POST',
        url: EXPORT_PATH,
        data: $('#transformation_form').serialize() + '&all_columns=' + this.state.allPossibleColumns,
        success: function (data) {
          this.setState({
            statusPath: data.status_path,
            filePath: data.file_path,
            statusPollingIntervalId: setInterval(this.updateStatus, STATUS_POLLING_INTERVAL)
          });
        }.bind(this),
        error: this.handleError
      });
    },

    cancelExport: function () {
      this.stopPolling();
      this.setState({
        exportStarted: false,
        exportFinished: false,
        statusPath: '',
        filePath: '',
        currentStatus: '',
        currentStatusMsg: '',
        statusPollingIntervalId: null
      });
    },

    updateStatus: function () {
      $.ajax({
        type: 'GET',
        url: this.state.statusPath,
        success: function(data) {
          this.setState({
            currentStatus: data.status,
            currentStatusMsg: data.status_msg
          });
          if (data.status === 'succeed' || data.status === 'failed') {
            this.stopPolling();
          }
        }.bind(this),
        error: this.handleError
      });
    },

    stopPolling: function () {
      if (this.state.statusPollingIntervalId) {
        clearInterval(this.state.statusPollingIntervalId);
      }
    },

    handleError: function (jqXHR) {
      this.stopPolling();
      var errorMsg = 'An error occurred. Please try again.';
      if (jqXHR.responseJSON && jqXHR.responseJSON.error) {
        errorMsg += '\n' + jqXHR.responseJSON.error;
      }
      this.setState({
        currentStatus: 'failed',
        currentStatusMsg: errorMsg
      });
    },

    exportSuccessfullyCompleted: function () {
      return this.state.currentStatus === 'succeed';
    },

    allPossibleColumnsChanged: function (e) {
      this.setState({allPossibleColumns: e.target.checked})
    },

    render: function () {
      if (!this.state.exportStarted) {
        return (
          <ExportButton onClick={this.startExport} allPossibleColumns={this.state.allPossibleColumns} onAllPossibleColumnsChanged={this.allPossibleColumnsChanged}/>
        )
      } else {
        return (
          <ProgressDialog onClose={this.cancelExport} status={this.state.currentStatus} content={this.state.currentStatusMsg}
                          filePath={this.state.filePath} downloadEnabled={this.exportSuccessfullyCompleted()}/>
        )
      }
    }
  });

  // Helper components:

  var ExportButton = React.createClass({
    render: function () {
      return (
        <div>
          <button className="btn btn-primary export-spreadsheet" data-loading-text="Processing..." onClick={this.props.onClick}>
            Export Spreadsheet
          </button>
          <input type="checkbox" checked={this.props.allPossibleColumns} onChange={this.props.onAllPossibleColumnsChanged}/>
          Export all possible columns
        </div>
      )
    }
  });

  var ProgressDialog = React.createClass({
    componentDidMount: function () {
      $(React.findDOMNode(this)).modal();
      $(React.findDOMNode(this)).on('hidden.bs.modal', function () {
        this.props.onClose();
      }.bind(this));
    },

    componentWillUnmount: function () {
      // Note that Bootstrap modifies body tag and possibly other DOM elements,
      // so make sure the dialog is hidden properly.
      $(React.findDOMNode(this)).modal('hide');
    },

    downloadHandler: function (e) {
      // Don't let users click the broken link.
      if (!this.props.downloadEnabled) {
        e.preventDefault();
      }
    },

    getStatusClass: function () {
      val = 'label ';
      if (this.props.status === 'succeed') {
        val += 'label-success';
      } else if (this.props.status === 'failed') {
        val += 'label-danger';
      } else if (this.props.status === 'requested') {
        val += 'label-default';
      } else {
        val += 'label-info';
      }
      return val;
    },

    render: function () {
      return (
        <div className="modal fade">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 className="modal-title">Spreadsheet export status:
                  <span> </span>
                  <span className={this.getStatusClass()}>{this.props.status}</span>
                </h4>
              </div>
              <div className="modal-body">
                <p>{this.props.content}</p>
                <p>{this.props.downloadEnabled ? "Use the button below to download exported logs." : ""}</p>
              </div>
              <div className="modal-footer">
                <a type="button" href={this.props.filePath} id="download-spreadsheet" className="btn btn-primary"
                   disabled={!this.props.downloadEnabled} onClick={this.downloadHandler}>Download spreadsheet</a>
              </div>
            </div>
          </div>
        </div>
      )
    }
  });

  return LogSpreadsheetExport;
});
