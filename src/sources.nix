{ ... }: {
  # Frozen upstream release artifacts.
  napcat_version = "v4.18.42";
  napcat_url = "https://github.com/XingYunStar/NapCatQQ/releases/download/v4.18.42/NapCat.Shell.zip";
  napcat_hash = "sha256-AuX/D3mRbB4EyBwbRZAFZAb7QpPx8TAMlV5x/Qiygp0=";

  qq_version = "3.2.34-2026-09-24";
  qq_sources = {
    aarch64-linux = {
      url = "https://github.com/a1515333102/QQ-Releases/releases/download/9.9.36%2B3.2.34/QQ_3.2.34_260924_arm64_01.deb";
      hash = "sha256-GBuJXLVzVI45blS7BUjMqS/9wbGksBj6RVG7BiOF/co=";
    };
    x86_64-linux = {
      url = "https://github.com/a1515333102/QQ-Releases/releases/download/9.9.36%2B3.2.34/QQ_3.2.34_260924_amd64_01.deb";
      hash = "sha256-Q2xl4d0oQi4SiiHL3bX+Ti5sB51/J/7CVB4BTTjMM24=";
    };
  };
}
