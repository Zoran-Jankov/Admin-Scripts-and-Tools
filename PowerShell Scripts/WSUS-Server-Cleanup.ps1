Get-WsusServer | Invoke-WsusServerCleanup `
						 -CleanupObsoleteComputers `
						 -CleanupObsoleteUpdates `
						 -CleanupUnneededContentFiles `
						 -CompressUpdates `
						 -DeclineExpiredUpdates `
                         -DeclineSupersededUpdates `
                         -Confirm:$false