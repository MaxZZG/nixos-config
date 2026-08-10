{ inputs, ... }:
{
  # 仅负责引入 home-manager nixosModule，具体用户配置在各 profile 中
  imports = [ inputs.home-manager.nixosModules.home-manager ];
}
