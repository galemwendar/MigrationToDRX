function downloadFileFromBase64(filename, base64) {
    const link = document.createElement('a');
    link.href = "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64," + base64;
    link.download = filename;
    link.click();
}
