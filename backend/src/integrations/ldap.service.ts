import ldap from 'ldapjs';

export interface LdapUser {
  dn: string;
  cn: string;
  [key: string]: any;
}

class LdapService {
  private url = process.env.LDAP_URL || 'ldap://localhost:389';
  private baseDN = process.env.LDAP_BASE_DN || '';

  async authenticate(username: string, password: string): Promise<LdapUser | null> {
    const client = ldap.createClient({ url: this.url });
    const userDN = `uid=${username},${this.baseDN}`;

    return new Promise((resolve, reject) => {
      client.bind(userDN, password, err => {
        if (err) {
          client.unbind();
          return resolve(null);
        }

        const opts = { scope: 'sub', filter: `(uid=${username})` };
        client.search(this.baseDN, opts, (searchErr, res) => {
          if (searchErr) {
            client.unbind();
            return reject(searchErr);
          }

          let user: LdapUser | null = null;
          res.on('searchEntry', entry => {
            user = entry.object as LdapUser;
          });
          res.on('error', e => {
            client.unbind();
            reject(e);
          });
          res.on('end', () => {
            client.unbind();
            resolve(user);
          });
        });
      });
    });
  }
}

export const ldapService = new LdapService();

