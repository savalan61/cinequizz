enum SubmissionStatus {
  idle,
  inProgress,
  success,
  timeoutError,
  error;

  bool get isLoading => this == SubmissionStatus.inProgress;
  bool get isSuccess => this == SubmissionStatus.success;
  bool get isTimeoutError => this == SubmissionStatus.timeoutError;
  bool get isError => this == SubmissionStatus.error;
}
