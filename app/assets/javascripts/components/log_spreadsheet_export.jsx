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
        statusPollingIntervalId: null
      }
    },

    componentWillUnmount: function () {
      this.stopPolling();
    },

    startExport: function () {
      this.setState({
        exportStarted: true,
        currentStatusMsg: 'Export requested.'
      });
      $.ajax({
        type: 'POST',
        url: EXPORT_PATH,
        data: $('#transformation_form').serialize(),
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

    render: function () {
      if (!this.state.exportStarted) {
        return (
          <ExportButton onClick={this.startExport}/>
        )
      } else {
        return (
          <ProgressDialog onClose={this.cancelExport} content={this.state.currentStatusMsg}
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

    render: function () {
      return (
        <div className="modal fade">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 className="modal-title">Spreadsheet Export Status</h4>
              </div>
              <div className="modal-body">
                <p>{this.props.content}</p>
                <p>{this.props.downloadEnabled ? "Use the button below to download exported logs." : ""}</p>
              </div>
              <div className="modal-footer">
                <a type="button" href={this.props.filePath} className="btn btn-primary" disabled={!this.props.downloadEnabled} onClick={this.downloadHandler}>Download spreadsheet</a>
              </div>
            </div>
          </div>
        </div>
      )
    }
  });

  return LogSpreadsheetExport;
});
