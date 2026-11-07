class Systemupdater < Formula
  desc "Unified update runner for Linux and macOS package managers and dev tools"
  homepage "https://github.com/Piotrunius/SystemUpdater"
  url "https://github.com/Piotrunius/SystemUpdater/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "4966f22e259eb73a35700d19337160449d93fcfab8a233bc21ee479dfed37dd7"
  version "1.5.5"
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
    (bin/"sysupdate").chmod 0755

    generate_completions_from_executable(bin/"sysupdate", "--generate-completion", shells: [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/sysupdate --version")
    assert_match "Installed version: #{version}", output
  end
end
