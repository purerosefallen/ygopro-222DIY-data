--A Hero's Armor is Always Crimson
function c77707040.initial_effect(c)
	--Change effect to nothing
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77707040,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c77707040.chcon)
	e1:SetTarget(c77707040.chtg)
	e1:SetOperation(c77707040.chop)
	c:RegisterEffect(e1)
end
function c77707040.chcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_HAND)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=10
end
function c77707040.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c77707040.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c77707040.repop)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		--Negate Grave effect
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_F)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(c77707040.discon)
		e2:SetTarget(c77707040.distg)
		e2:SetOperation(c77707040.disop)
		c:RegisterEffect(e2)
	end
end
function c77707040.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
end
function c77707040.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_GRAVE and Duel.IsChainNegatable(ev)
end
function c77707040.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77707040.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end