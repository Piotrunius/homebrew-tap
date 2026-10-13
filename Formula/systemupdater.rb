class Systemupdater < Formula
  desc "Unified update runner for Linux and macOS package managers and dev tools"
  homepage "https://github.com/Piotrunius/SystemUpdater"
  url "https://github.com/Piotrunius/SystemUpdater/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a81481222fa6759c3d644ef35b0a8074a9266880d9ca294bd502b1ac95263581"
  version "1.3.1"
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
