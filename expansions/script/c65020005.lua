--幻念的朱町
function c65020005.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)
	--back
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65020005.pthcon)
	e1:SetTarget(c65020005.pthtg)
	e1:SetOperation(c65020005.pthop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65020005,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,65020005)
	e2:SetCondition(c65020005.pcon)
	e2:SetTarget(c65020005.ptg)
	e2:SetOperation(c65020005.pop)
	c:RegisterEffect(e2)
	--handquick
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,65020105)
	e3:SetCondition(c65020005.hdcon)
	e3:SetCost(c65020005.hdcost)
	e3:SetTarget(c65020005.hdtg)
	e3:SetOperation(c65020005.hdop)
	c:RegisterEffect(e3)
end

function c65020005.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and ep~=tp
end

function c65020005.mifil(c)
	return c:IsSetCard(0x9da1) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end

function c65020005.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(c65020005.mifil,tp,LOCATION_HAND,0,2,c) end
	local g=Duel.SelectMatchingCard(tp,c65020005.mifil,tp,LOCATION_HAND,0,2,2,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.ShuffleHand(tp)
end

function c65020005.hdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65020005.hdop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		Duel.Destroy(ec,REASON_EFFECT)
	end
end

function c65020005.pthcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c65020005.pthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end

function c65020005.pthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end

function c65020005.pcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c65020005.pfilter(c)
	return c:IsSetCard(0x9da1) and c:IsType(TYPE_PENDULUM)
end

function c65020005.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020005.pfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c65020005.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c65020005.pfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
