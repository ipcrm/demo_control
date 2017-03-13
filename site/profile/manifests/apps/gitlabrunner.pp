class profile::apps::gitlabrunner (
  $registration_token,
  $gitlab_host,
)
{

  $gitlab_ci_runners = { 'test_runner1' => '' }
  $gitlab_runner_defaults = {
    url                => "http://${gitlab_host}/ci",
    executor           => 'shell',
    registration-token => $registration_token,
  }

  class{ '::gitlab::cirunner': }

  gitlab::runner { keys($gitlab_ci_runners):
    runners_hash   => $gitlab_ci_runners,
    default_config => $gitlab_runner_defaults,
  }

}
