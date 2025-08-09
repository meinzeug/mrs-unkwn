import crypto from 'crypto';

interface Invitation {
  token: string;
  familyId: string;
  email: string;
  role: string;
  expiresAt: number;
}

const invitations = new Map<string, Invitation>();

export const familyService = {
  inviteMember(familyId: string, email: string, role: string): void {
    const token = crypto.randomBytes(16).toString('hex');
    invitations.set(token, {
      token,
      familyId,
      email,
      role,
      expiresAt: Date.now() + 24 * 60 * 60 * 1000,
    });
    console.log(`Invitation sent to ${email} with token ${token}`);
  },

  acceptInvitation(token: string) {
    const invite = invitations.get(token);
    if (!invite || invite.expiresAt < Date.now()) {
      throw new Error('Invalid or expired token');
    }
    invitations.delete(token);
    return {
      id: invite.familyId,
      name: 'Demo Family',
      createdBy: '',
      subscriptionTier: 'basic',
      settings: null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      members: [
        {
          userId: 'invited',
          role: invite.role,
          permissions: [],
          joinedAt: new Date().toISOString(),
        },
      ],
    };
  },
};
