{ inputs, den, ... }:
{
  _module.args.__findFIle = den.lib.__findFile;
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "my" true)
  ];
}
