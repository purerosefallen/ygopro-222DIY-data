--辉忆的初心 感怀
function c65020063.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65020063.lcheck)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65020063.regcon)
	e1:SetOperation(c65020063.regop)
	c:RegisterEffect(e1)
end
function c65020063.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function c65020063.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65020063.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_RITUAL)
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c65020063.e1tg)
		e1:SetValue(500)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65020063,0))
	end
	if ct>=3 then
		--act limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(c65020063.chainop)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65020063,1))
	end
	if ct==4 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetTarget(c65020063.distg)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65020063,2))
	end
end
function c65020063.e1tg(e,c)
	return c==e:GetHandler() or c:IsType(TYPE_RITUAL)
end
function c65020063.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsType(TYPE_RITUAL) and ((rc:IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) or rc:IsType(TYPE_MONSTER)) then
		Duel.SetChainLimit(c65020063.chainlm)
	end
end
function c65020063.chainlm(e,rp,tp)
	local c=e:GetHandler()
	return not (tp~=rp and (e:IsActiveType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA))
end
function c65020063.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end