import PDFDocument from 'pdfkit';
import fs from 'node:fs';

/// Genera el reporte de visita en PDF y lo transmite directo a la
/// respuesta HTTP (streaming), sin guardar un archivo temporal en disco.
export function generarReporteVisita(visita, res) {
  const doc = new PDFDocument({ margin: 50 });
  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader('Content-Disposition', `attachment; filename="visita-${visita.id}.pdf"`);
  doc.pipe(res);

  doc.fontSize(18).text('Reporte de visita técnica · Nivel digital de obra', { align: 'center' });
  doc.moveDown();
  doc.fontSize(11);
  doc.text(`Técnico: ${visita.tecnico}`);
  doc.text(`Mástil: ${visita.mastil}`);
  doc.text(`Azimut objetivo: ${visita.azimutObjetivo}°`);
  doc.text(`Iniciada: ${visita.iniciadaEn.toISOString()}`);
  if (visita.cerradaEn) doc.text(`Cerrada: ${visita.cerradaEn.toISOString()}`);
  doc.moveDown();

  doc.fontSize(14).text('Mediciones', { underline: true });
  doc.moveDown(0.5);

  visita.mediciones.forEach((m, i) => {
    doc.fontSize(11).text(
      `${i + 1}. Inclinación X: ${m.inclinacionX.toFixed(1)}°  ·  Y: ${m.inclinacionY.toFixed(1)}°  ·  ` +
        `Azimut: ${m.azimut.toFixed(1)}° (objetivo ${m.azimutObjetivo.toFixed(1)}°)  ·  ` +
        `${m.cumple ? 'CUMPLE' : 'NO CUMPLE'}`,
    );
    if (fs.existsSync(m.fotoRuta)) {
      try {
        doc.image(m.fotoRuta, { width: 200 });
      } catch {
        doc.text('(no se pudo incrustar la fotografía)');
      }
    }
    doc.moveDown();
  });

  const totalCumple = visita.mediciones.filter((m) => m.cumple).length;
  doc.moveDown();
  doc
    .fontSize(12)
    .text(`Resumen: ${totalCumple} de ${visita.mediciones.length} mediciones dentro de tolerancia.`);

  doc.end();
}
