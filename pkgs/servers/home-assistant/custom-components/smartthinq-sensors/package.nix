{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  charset-normalizer,
  pycountry,
  xmltodict,
}:

buildHomeAssistantComponent rec {
  owner = "ollo69";
  domain = "smartthinq_sensors";
  version = "0.41.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-smartthinq-sensors";
    tag = "v${version}";
    hash = "sha256-L0diABbUq/0wmwvhHeMOg6ieNrvM+LWZ/ynezEpBblk=";
  };

  dependencies = [
    charset-normalizer
    pycountry
    xmltodict
  ];

  meta = with lib; {
    description = "Home Assistant custom integration for SmartThinQ LG devices configurable with Lovelace User Interface";
    homepage = "https://github.com/ollo69/ha-smartthinq-sensors";
    changelog = "https://github.com/ollo69/ha-smartthinq-sensors/releases/tag/v${version}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.asl20;
  };
}
