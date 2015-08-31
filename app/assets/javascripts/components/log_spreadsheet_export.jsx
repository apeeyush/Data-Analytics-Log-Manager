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
      $.ajax({
        type: 'POST',
        url: EXPORT_PATH,
        data: $('#transformation_form').serialize(),
        success: function(data) {
          this.setState({
            exportStarted: true,
            statusPath: data.status_path,
            filePath: data.file_path,
            currentStatusMsg: 'Export requested',
            statusPollingIntervalId: setInterval(this.updateStatus, STATUS_POLLING_INTERVAL)
          });
        }.bind(this),
        error: function() {
          alert('An error occurred! Please try again.');
          this.cancelExport();
        }
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
        error: function() {
          alert('An error occurred! Please try again.');
          this.cancelExport();
        }
      });
    },

    stopPolling: function () {
      if (this.state.statusPollingIntervalId) {
        clearInterval(this.state.statusPollingIntervalId);
      }
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
                <button type="button" className="close" data-dismiss="modal" aria-label="Close" onClick={this.props.onClose}>
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 className="modal-title">Spreadsheet Export Status</h4>
              </div>
              <div className="modal-body">
                <p>{this.props.content}.</p>
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
