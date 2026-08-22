class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://atlassiancli.com"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.7.2/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5d43602c15ca2b1f3b933f7f5f92fe1874b0ae41b74101067fc4008047cc9201"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.7.2/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e6413869973cc53633acfda9d917c8859f57f40b8751b9718e4d32815c296f65"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/omar16100/atlassian-cli/releases/download/v0.7.2/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a4c58071ad961c602ad309c78646a37a68e26e253f632f9639d0ac8cb0ca05a1"
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
