const fs = require('fs');
const path = require('path');

// Simple SVG to PNG conversion using sharp
async function generateIcons() {
  try {
    const sharp = require('sharp');

    const svgPath = path.join(__dirname, '..', 'assets', 'logo.svg');
    const iconDir = path.join(__dirname, '..', 'assets', 'icon');

    // Ensure icon directory exists
    if (!fs.existsSync(iconDir)) {
      fs.mkdirSync(iconDir, { recursive: true });
    }

    const svgBuffer = fs.readFileSync(svgPath);

    // Generate PNG at 512x512
    console.log('Generating logo.png (512x512)...');
    await sharp(svgBuffer)
      .resize(512, 512)
      .png()
      .toFile(path.join(iconDir, 'logo.png'));

    // Generate multiple sizes for ICO
    const sizes = [16, 32, 48, 64, 128, 256];
    const pngBuffers = [];

    for (const size of sizes) {
      console.log(`Generating ${size}x${size} PNG...`);
      const buffer = await sharp(svgBuffer)
        .resize(size, size)
        .png()
        .toBuffer();
      pngBuffers.push({ size, buffer });
    }

    // Create ICO file manually
    console.log('Generating logo.ico...');
    const icoBuffer = createIco(pngBuffers);
    fs.writeFileSync(path.join(iconDir, 'logo.ico'), icoBuffer);

    // For ICNS, we just create the PNG - macOS tools needed for proper ICNS
    console.log('Generating logo.icns placeholder (use iconutil on macOS for proper ICNS)...');
    await sharp(svgBuffer)
      .resize(1024, 1024)
      .png()
      .toFile(path.join(iconDir, 'logo.icns.png'));

    console.log('Icons generated successfully!');
    console.log('Note: For proper .icns, convert logo.icns.png on macOS using iconutil');

  } catch (error) {
    console.error('Error generating icons:', error.message);
    console.log('Installing sharp...');

    const { execSync } = require('child_process');
    execSync('npm install sharp --save-dev', { stdio: 'inherit' });

    console.log('Sharp installed. Please run this script again.');
  }
}

// Create ICO file from PNG buffers
function createIco(pngBuffers) {
  // ICO header
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0); // Reserved
  header.writeUInt16LE(1, 2); // Type: 1 = ICO
  header.writeUInt16LE(pngBuffers.length, 4); // Number of images

  // Calculate offsets
  let offset = 6 + (pngBuffers.length * 16); // Header + directory entries
  const entries = [];
  const imageData = [];

  for (const { size, buffer } of pngBuffers) {
    // Directory entry (16 bytes each)
    const entry = Buffer.alloc(16);
    entry.writeUInt8(size === 256 ? 0 : size, 0); // Width (0 = 256)
    entry.writeUInt8(size === 256 ? 0 : size, 1); // Height (0 = 256)
    entry.writeUInt8(0, 2); // Color palette
    entry.writeUInt8(0, 3); // Reserved
    entry.writeUInt16LE(1, 4); // Color planes
    entry.writeUInt16LE(32, 6); // Bits per pixel
    entry.writeUInt32LE(buffer.length, 8); // Size of image data
    entry.writeUInt32LE(offset, 12); // Offset to image data

    entries.push(entry);
    imageData.push(buffer);
    offset += buffer.length;
  }

  return Buffer.concat([header, ...entries, ...imageData]);
}

generateIcons();
