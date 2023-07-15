using Microsoft.AspNetCore.Mvc;
using PdfSharp;
using PdfSharp.Drawing;
using PdfSharp.Pdf;
using PdfSharp.Pdf.Content;
using PdfSharp.Pdf.Content.Objects;
using PdfSharp.Pdf.IO;
using System.Drawing;

namespace PDFReader1.Controllers
{
    public class PdfReaderController : Controller
    {
        public IActionResult Index()
        {
            ReadPdfFile();
            return View();
        }

        public void HighlightTextLocations(string filePath)
        {
            using (PdfDocument document = PdfReader.Open(filePath))
            {
                for (int pageIndex = 0; pageIndex < document.PageCount; pageIndex++)
                {
                    PdfPage page = document.Pages[pageIndex];

                    //HighlightText(page, 0.8978, 0.6732, (1.0888 - 0.6732), (1.036 - 0.6732));
                    //HighlightText(page, 400, 400, 200, 200);

                    double x = 0.8978 * page.Width / 8.5;
                    double y = 0.6732 * page.Height / 11;
                    double width = (1.0888 - 0.6732) * page.Width / 8.5;
                    double height = (1.036 - 0.6732) * page.Height / 11;
                    HighlightText(page, x, y, width, height);
                }
                document.Save(@"C:\Users\User\Downloads\Highlighted.pdf");
            }
        }

        private void HighlightText(PdfPage page, double x, double y, double width, double height)
        {
            using (XGraphics gfx = XGraphics.FromPdfPage(page))
            {
                XRect rect = new XRect(x, y, width, height);
                XColor fillColor = XColor.FromArgb(127, XColors.Black);

                gfx.DrawRectangle(new XPen(fillColor, 0), rect);
                gfx.DrawRectangle(new XSolidBrush(fillColor), rect);
            }
        }

        public void ReadPdfFile()
        {
            string filePath = @"C:\Users\User\Downloads\sample.pdf";
            HighlightTextLocations(filePath);
        }
    }
}
