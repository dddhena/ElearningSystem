using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ElearningSystemElective.Startup))]
namespace ElearningSystemElective
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
