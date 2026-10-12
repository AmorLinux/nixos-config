/**
 * Permission Gate Extension (adaptada del ejemplo oficial de Pi)
 *
 * Pide confirmación antes de ejecutar comandos potencialmente peligrosos
 * con la herramienta bash. En modo no interactivo, BLOQUEA por defecto.
 *
 * Patrones: rm -rf, sudo, chmod/chown 777, nixos-rebuild, home-manager switch,
 * nix-collect-garbage, git push --force, mkfs, dd a dispositivos.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const dangerousPatterns = [
		/\brm\s+(-[a-zA-Z]*[rf][a-zA-Z]*|--recursive|--force)/i,
		/\bsudo\b/i,
		/\b(chmod|chown)\b.*777/i,
		/\bnixos-rebuild\b/i,
		/\bhome-manager\b.*\bswitch\b/i,
		/\bnix-collect-garbage\b/i,
		/\bgit\s+push\b.*(--force|-f)\b/i,
		/\bmkfs\b/i,
		/\bdd\b[^|]*\bof=\/dev\//i,
	];

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;

		const command = event.input.command as string;
		const isDangerous = dangerousPatterns.some((p) => p.test(command));

		if (isDangerous) {
			if (!ctx.hasUI) {
				// En modo no interactivo, bloquear por defecto
				return { block: true, reason: "Comando peligroso bloqueado (sin UI para confirmar)" };
			}

			const choice = await ctx.ui.select(`⚠️ Comando peligroso:\n\n  ${command}\n\n¿Permitir?`, ["Sí", "No"]);

			if (choice !== "Sí") {
				return { block: true, reason: "Bloqueado por el usuario" };
			}
		}

		return undefined;
	});
}
