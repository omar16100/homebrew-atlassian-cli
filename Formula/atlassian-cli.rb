class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassiancli.com"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.5.0/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7621f19e1fdc63b84ce847d62155cac3b0fb6fb8539004088f6ed58aeb9bc261"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.5.0/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2c58270b0224b965432f73c0418ffa7fce639e879d3959e50078633bf7b54d18"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.5.0/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fa20c2f38e54e4d1de1b3ca50074671d30753af1035cc0b44e816ea78731f58e"
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
    bin.install "atlassian-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "atlassian-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "atlassian-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
