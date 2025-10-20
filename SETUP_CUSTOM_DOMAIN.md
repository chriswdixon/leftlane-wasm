# Make WordPress Playground WASM the Front Page of leftlane.io

This guide shows you how to point leftlane.io to your WordPress Playground WASM site on GitHub Pages.

## Overview

You'll configure your domain (leftlane.io) to point to:
```
https://chriswdixon.github.io/leftlane-wasm/
```

So visitors to `https://leftlane.io` will see your WordPress Playground WASM site.

---

## Step-by-Step Setup

### Step 1: Add CNAME File to Repository

This tells GitHub Pages what custom domain to use.

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Create CNAME file with your domain
echo "leftlane.io" > CNAME

# Commit and push
git add CNAME
git commit -m "Add custom domain leftlane.io"
git push
```

### Step 2: Configure DNS at Your Domain Registrar

Log in to your domain registrar (where you bought leftlane.io - GoDaddy, Namecheap, Cloudflare, etc.) and update DNS settings:

#### Option A: Apex Domain (leftlane.io) - Recommended

Add **4 A records** pointing to GitHub Pages:

```
Type: A
Name: @
Value: 185.199.108.153

Type: A
Name: @
Value: 185.199.109.153

Type: A
Name: @
Value: 185.199.110.153

Type: A
Name: @
Value: 185.199.111.153
```

#### And add WWW CNAME:

```
Type: CNAME
Name: www
Value: chriswdixon.github.io
```

This ensures both `leftlane.io` and `www.leftlane.io` work.

#### Option B: WWW Only (www.leftlane.io)

If you only want www to work:

```
Type: CNAME
Name: www
Value: chriswdixon.github.io
```

Then add a redirect from apex to www at your registrar.

---

### Step 3: Configure GitHub Pages

1. Go to https://github.com/chriswdixon/leftlane-wasm/settings/pages
2. Wait for DNS to propagate (can take 24-48 hours)
3. Once DNS is propagated, you'll see a green checkmark
4. Check "Enforce HTTPS" (wait until certificate is issued)

---

### Step 4: Wait for DNS Propagation

DNS changes take time:
- **Minimum**: 1-2 hours
- **Typical**: 4-6 hours
- **Maximum**: 24-48 hours

Check propagation status:
```bash
# Check A records
dig leftlane.io

# Check CNAME
dig www.leftlane.io

# Or use online tool
open https://www.whatsmydns.net/#A/leftlane.io
```

---

## What Happens to Your Current leftlane.io Site?

**Important:** Pointing leftlane.io to GitHub Pages means your current WordPress site at leftlane.io will no longer be accessible at that domain.

### Options to Keep Your Current Site:

#### Option 1: Use a Subdomain for Current Site

Move current WordPress to subdomain:
- Current site: `legacy.leftlane.io` or `wp.leftlane.io`
- New WASM site: `leftlane.io`

DNS Setup:
```
# New WASM site at main domain
Type: A, Name: @, Value: 185.199.108.153 (+ 3 more)

# Current WordPress at subdomain
Type: A, Name: legacy, Value: [your-current-hosting-ip]
```

#### Option 2: Use Subdomain for WASM Site

Keep current site as main:
- Current site: `leftlane.io`
- New WASM site: `playground.leftlane.io`

DNS Setup:
```
# Keep current A records for leftlane.io

# Add CNAME for playground subdomain
Type: CNAME
Name: playground
Value: chriswdixon.github.io
```

Update CNAME file:
```bash
echo "playground.leftlane.io" > CNAME
git add CNAME
git commit -m "Use playground subdomain"
git push
```

#### Option 3: Use Different Domain

Keep current site at leftlane.io and use a different domain for WASM:
- Current site: `leftlane.io`
- New WASM site: `leftlane.app` or `tryleftlane.io` (if you own them)

---

## Complete DNS Configuration Examples

### Configuration 1: WASM as Main Site (Recommended)

**Result:** 
- `leftlane.io` → WordPress Playground WASM
- `www.leftlane.io` → WordPress Playground WASM  
- `wp.leftlane.io` → Your current WordPress site

**DNS Records:**
```
# GitHub Pages for main domain
Type: A, Name: @, Value: 185.199.108.153
Type: A, Name: @, Value: 185.199.109.153
Type: A, Name: @, Value: 185.199.110.153
Type: A, Name: @, Value: 185.199.111.153

# WWW redirect
Type: CNAME, Name: www, Value: chriswdixon.github.io

# Current WordPress on subdomain
Type: A, Name: wp, Value: [your-current-hosting-ip]
```

**CNAME file:**
```
leftlane.io
```

### Configuration 2: WASM on Subdomain (Keep Current Site)

**Result:**
- `leftlane.io` → Your current WordPress site
- `playground.leftlane.io` → WordPress Playground WASM

**DNS Records:**
```
# Keep your current DNS for leftlane.io (don't change)

# Add CNAME for playground
Type: CNAME, Name: playground, Value: chriswdixon.github.io
```

**CNAME file:**
```
playground.leftlane.io
```

### Configuration 3: Both Side-by-Side

**Result:**
- `leftlane.io` → Your current WordPress site
- `try.leftlane.io` → WordPress Playground WASM (for demos/testing)

**DNS Records:**
```
# Keep current records for main domain

# Add CNAME for try subdomain
Type: CNAME, Name: try, Value: chriswdixon.github.io
```

**CNAME file:**
```
try.leftlane.io
```

---

## My Recommendation

Based on your use case, I recommend **Configuration 2** (subdomain):

### Why?
✅ **Keep your current site running** at leftlane.io  
✅ **Add WASM testing environment** at playground.leftlane.io  
✅ **No downtime** - both sites work simultaneously  
✅ **Easy to test** - Try WASM before making it primary  
✅ **Professional** - Clear separation of production vs testing  

### Implementation

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Use playground subdomain
echo "playground.leftlane.io" > CNAME

git add CNAME
git commit -m "Configure playground.leftlane.io subdomain"
git push
```

Then add this DNS record at your registrar:
```
Type: CNAME
Name: playground
Value: chriswdixon.github.io
```

After DNS propagates, access at:
- **Main site:** https://leftlane.io (current WordPress)
- **Playground:** https://playground.leftlane.io (WASM site)

---

## Detailed DNS Provider Instructions

### GoDaddy

1. Log in to GoDaddy.com
2. Go to My Products → Domains
3. Click DNS next to leftlane.io
4. Click "Add" to add new records
5. Add the A records or CNAME as needed
6. Save changes

### Namecheap

1. Log in to Namecheap.com
2. Dashboard → Domain List
3. Click "Manage" next to leftlane.io
4. Go to Advanced DNS tab
5. Add new records
6. Save changes

### Cloudflare

1. Log in to Cloudflare.com
2. Select leftlane.io domain
3. Go to DNS section
4. Add records
5. Set proxy status (orange cloud icon)
   - For GitHub Pages, use "DNS only" (gray cloud)
6. Save

### Other Providers

The process is similar - look for:
- DNS Management
- DNS Settings
- Advanced DNS
- Manage DNS

---

## Testing Your Setup

### Test DNS Propagation

```bash
# Check A records (for apex domain)
dig leftlane.io

# Should show GitHub IPs:
# 185.199.108.153
# 185.199.109.153
# 185.199.110.153
# 185.199.111.153

# Check CNAME (for subdomain)
dig playground.leftlane.io

# Should show: chriswdixon.github.io
```

### Online Tools

- https://www.whatsmydns.net/
- https://dnschecker.org/
- https://mxtoolbox.com/DNSLookup.aspx

### Test in Browser

```bash
# Test your setup
open https://leftlane.io
# or
open https://playground.leftlane.io
```

---

## Enable HTTPS (SSL Certificate)

GitHub Pages provides free SSL certificates automatically!

### Steps:

1. Wait for DNS to fully propagate (24-48 hours)
2. Go to https://github.com/chriswdixon/leftlane-wasm/settings/pages
3. You'll see your custom domain listed
4. GitHub will automatically issue SSL certificate
5. Check "Enforce HTTPS" once certificate is ready
6. Done! Your site will have HTTPS

### Certificate Status

Check here:
```
https://github.com/chriswdixon/leftlane-wasm/settings/pages
```

You'll see one of:
- ⏳ Certificate pending (wait)
- ✅ Certificate issued (enable HTTPS)
- ❌ Error (check DNS settings)

---

## Troubleshooting

### Site Shows 404

**Cause:** DNS not propagated or CNAME file incorrect

**Fix:**
1. Check CNAME file contains correct domain
2. Wait longer for DNS propagation
3. Clear browser cache
4. Try incognito/private window

### SSL Certificate Not Issuing

**Cause:** DNS not fully propagated or CAA records blocking

**Fix:**
1. Wait 24-48 hours after DNS changes
2. Check DNS propagation globally
3. Verify no CAA records blocking Let's Encrypt
4. Temporarily remove and re-add custom domain in GitHub

### WWW Not Working

**Cause:** Missing CNAME record for www

**Fix:**
Add DNS record:
```
Type: CNAME
Name: www
Value: chriswdixon.github.io
```

### Redirect Loop

**Cause:** Conflicting redirects or proxy settings

**Fix:**
- If using Cloudflare, set to "DNS only" (gray cloud)
- Check for conflicting redirects at registrar
- Clear browser cache

---

## Migration Timeline

Here's what to expect:

### Immediate (0-5 minutes)
- Create CNAME file
- Push to GitHub
- Update DNS records

### Short Wait (1-4 hours)
- DNS starts propagating
- Some locations see new site
- Others still see old site

### Medium Wait (4-24 hours)
- Most DNS servers updated
- Site accessible at custom domain
- SSL certificate may not be ready

### Full Propagation (24-48 hours)
- All DNS servers updated
- SSL certificate issued
- HTTPS working perfectly
- Site fully live

---

## Rollback Plan

If something goes wrong, you can easily rollback:

### Quick Rollback

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Remove CNAME file
git rm CNAME
git commit -m "Remove custom domain"
git push

# Go to GitHub Settings → Pages
# Remove custom domain
```

Then restore your original DNS records at your registrar.

---

## Which Option Should You Choose?

### Choose Main Domain (leftlane.io) if:
- ✅ You want WASM as your primary site
- ✅ You're ready to migrate away from current site
- ✅ You've backed up everything
- ✅ You want the simplest URL

### Choose Subdomain (playground.leftlane.io) if:
- ✅ You want to keep current site running
- ✅ You want to test WASM alongside existing site
- ✅ You want a dedicated testing environment
- ✅ You're not ready for full migration

**My Recommendation:** Start with subdomain, then migrate to main domain later if desired.

---

## Next Steps

1. **Decide which configuration** you want (main domain or subdomain)
2. **Run the commands** below for your choice
3. **Update DNS** at your registrar
4. **Wait for propagation** (24-48 hours)
5. **Enable HTTPS** once certificate issues
6. **Test thoroughly** before announcing

---

## Ready to Set It Up?

### For Subdomain Setup (Recommended):

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Use playground subdomain
echo "playground.leftlane.io" > CNAME

git add CNAME
git commit -m "Configure playground.leftlane.io subdomain"
git push
```

**Then add DNS record:**
```
Type: CNAME
Name: playground  
Value: chriswdixon.github.io
```

**Access at:** https://playground.leftlane.io

---

### For Main Domain Setup:

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Use main domain
echo "leftlane.io" > CNAME

git add CNAME
git commit -m "Configure leftlane.io as primary domain"
git push
```

**Then add DNS records:**
```
Type: A, Name: @, Value: 185.199.108.153
Type: A, Name: @, Value: 185.199.109.153
Type: A, Name: @, Value: 185.199.110.153
Type: A, Name: @, Value: 185.199.111.153
Type: CNAME, Name: www, Value: chriswdixon.github.io
```

**Access at:** https://leftlane.io

---

Let me know which option you prefer and I can help you set it up!

