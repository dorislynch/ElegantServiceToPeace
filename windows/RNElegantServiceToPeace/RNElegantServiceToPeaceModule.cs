using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Elegant.Service.To.Peace.RNElegantServiceToPeace
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNElegantServiceToPeaceModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNElegantServiceToPeaceModule"/>.
        /// </summary>
        internal RNElegantServiceToPeaceModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNElegantServiceToPeace";
            }
        }
    }
}
