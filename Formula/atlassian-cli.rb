class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassiancli.com"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.2/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f686ccd3a670f0f7d8940a1d6de04c8c1044c172401ac1c2dc50392bfa9eb5cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.2/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "dfa2815ee664caafb12d8fb8be36391e1ddaf79756bd75923e6a0f8dfc929699"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.3.2/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "982ace7ba17533477111d8333a10f164c85b70df4d113dd6e3ebbb790817305c"
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
