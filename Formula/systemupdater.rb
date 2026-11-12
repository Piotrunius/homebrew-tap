class Systemupdater < Formula
  desc "Unified update runner for Linux and macOS package managers and dev tools"
  homepage "https://github.com/Piotrunius/SystemUpdater"
  url "https://github.com/Piotrunius/SystemUpdater/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "cd161bdb299e2839f8e13fc45b49c28232540d73b1ebc80adf86ff0fdd0ae318"
  version "1.7.0"
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
