class Systemupdater < Formula
  desc "Unified update runner for Linux and macOS package managers and dev tools"
  homepage "https://github.com/Piotrunius/SystemUpdater"
  url "https://github.com/Piotrunius/SystemUpdater/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "1d390ea36359db29101dc55d232ea87f1282ea5ce0663df7a3dd22333e9db9ac"
  version "1.4.3"
  license "MIT"

  depends_on "python@3"

  def install
    libexec.install Dir["*.py"]
    libexec.install "modules"
    (libexec/".homebrew-install").write("homebrew\n")
    (libexec/"VERSION").write("#{version}\n")

    python = Formula["python@3"].opt_bin/"python3"
    (bin/"sysupdate").write <<~EOS
      #!/bin/bash
      exec "#{python}" "#{libexec}/main.py" "$@"
    EOS
  end

  test do
    output = shell_output("#{bin}/sysupdate --version")
    assert_match "Installed version: #{version}", output
  end
end
