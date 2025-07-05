using System;

namespace ExcelToOdata.Data.Models;

public class EdmxField
{
        public string? Name { get; set; }
        public string? Type { get; set; }
        public bool Nullable { get; set; }
        public string? Summary => $"{Name} ({Type}) {(Nullable ? "Nullable" : "Not Nullable")}";
}
