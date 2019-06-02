--rampage
local scard = c77702001
local id = 77702001
function scard.initial_effect(c)
	local function lose_lp(p,v)
		local old_lp=Duel.GetLP(p)
		if old_lp>v then
			Duel.SetLP(p,old_lp-v)
		else
			Duel.SetLP(p,0)
		end
	end
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(scard.regtg)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			lose_lp(p,1000)
		end
	end)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Cannot activate
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1, 0)
	e3:SetValue(scard.efilter)
	c:RegisterEffect(e3)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1, 0)
	e3:SetValue(function(e,c) return c:IsType(TYPE_FIELD) end)
	c:RegisterEffect(e3)
	local function f(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,p,true,true,POS_FACEUP_ATTACK)
	end
	local function check(p,e)
		return Duel.GetLocationCountFromEx(p)>0 and Duel.IsExistingMatchingCard(f,p,LOCATION_EXTRA,0,1,nil,e,p)
	end
	local function check_conflict()
		local zones={}
		for p=0,1 do
			local _,zone_raw=Duel.GetLocationCountFromEx(p)
			local zone=(~zone_raw)&0x7f
			zones[p]=zone
		end
		local shared_zones=zones[0]&zones[1]
		local total_zones=zones[0]|zones[1]
		return shared_zones&(shared_zones-1)>0 or total_zones&(~shared_zones)>0
	end
	local function check_all(e)
		return check(0,e) and check(1,e) and check_conflict()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentPhase()==PHASE_MAIN1
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return check_all(e) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_EXTRA)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not check_all(e) then return end
		local spc={}
		for p=0,1 do
			local g=Duel.GetMatchingGroup(f,p,LOCATION_EXTRA,0,nil,e,p)
			local c=g:RandomSelect(tp,1):GetFirst()
			spc[p]=c
		end
		for p=0,1 do
			local c=spc[p]
			Duel.SpecialSummonStep(c,0,p,p,true,true,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_YPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
		Duel.AdjustInstantly()
		Duel.CalculateDamage(spc[tp],spc[1-tp])
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:GetHandler()~=e:GetHandler()
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		lose_lp(ep,300)
	end)
	c:RegisterEffect(e2)
end
function scard.efilter(e, re, tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function scard.regtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	local c = e:GetHandler()
	--to grave
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE + PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(scard.gycon)
	e1:SetOperation(scard.gyop)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function scard.gycon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == tp
end
function scard.gyop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ct = c:GetTurnCounter()
	ct = ct + 1
	c:SetTurnCounter(ct)
	if ct == 7 then
		if (Duel.GetLP(0)~=8000 or Duel.GetLP(1)~=8000) and Duel.SelectYesNo(tp,id*16) then
			Duel.SetLP(0,8000)
			Duel.SetLP(1,8000)
			c:SetTurnCounter(0)
		else
			Duel.SendtoGrave(c, REASON_RULE)
		end
	end
end
