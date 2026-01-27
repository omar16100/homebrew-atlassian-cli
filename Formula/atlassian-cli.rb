class AtlassianCli < Formula
  desc "Unified CLI for Atlassian Cloud products"
  homepage "https://github.com/omar16100/atlassian-cli"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.2.5/atlassian-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7c0ae23081e172761713e5403ea6eee1177a48f30144cef3864d8ce990201934"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.2.5/atlassian-cli-x86_64-apple-darwin.tar.xz"
      sha256 "068fe6034c3fc40535a85f5376b63d49cfb066a5b2e8661fd2b0452aa7e78912"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/omar16100/atlassian-cli/releases/download/v0.2.5/atlassian-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84d2abc6a5f8135532a35cf168e822a55709e71553cdb79b899cc385665230c6"
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
