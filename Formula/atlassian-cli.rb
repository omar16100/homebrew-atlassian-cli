class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassian-cli.pages.dev"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.9.1/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "cff985decbdfde55f657ca1c6e860621faa9c9073ccc5b357a87dda1d8efd049"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.9.1/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8defa6f698513c370b7c52adeb1ae8112825e679bacde64442951eb3376cd98f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.9.1/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "869352f6dace935dbb983602c2177cc484964ce8c82a2a3695eb9ad9bee6ea50"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "atlassian-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "atlassian-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "atlassian-cli"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
