using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.IO;
using Cydin.Builder;
using Cydin.Models;

namespace Cydin.Controllers
{
	public class PackageUploadHandler : IRouteHandler, IHttpHandler
	{
		public IHttpHandler GetHttpHandler (RequestContext requestContext)
		{
			return this;
		}

		public bool IsReusable
		{
			get { return true; }
		}

		public void ProcessRequest (HttpContext context)
		{
			Cydin.Builder.BuildService.CheckClient ();
			
			string appId = context.Request.Headers ["applicationId"];
			string sourceTagId = context.Request.Headers ["sourceTagId"];
			string fileName = context.Request.Headers ["fileName"];
			
			SourceTag stag;
			using (UserModel m = UserModel.GetAdmin (int.Parse (appId))) {
				stag = m.GetSourceTag (int.Parse (sourceTagId));
			}
			string path = Path.Combine (stag.PackagesPath, fileName);
			
			string dir = Path.GetDirectoryName (path);
			if (!Directory.Exists (dir))
				Directory.CreateDirectory (dir);
			
			SaveToFile (context.Request.InputStream, path);
			context.Response.Write ("OK");
		}


		private static void SaveToFile (Stream inStream, string path)
		{
			byte [] buffer = new byte [32768];
			int n = 0;
			Stream outStream = null;
			try {
				outStream = File.Create (path);
				while ((n = inStream.Read (buffer, 0, buffer.Length)) > 0)
					outStream.Write (buffer, 0, n);
			} finally {
				inStream.Close ();
				if (outStream != null)
					outStream.Close ();
			}
		}
	}
}