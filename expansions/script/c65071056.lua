--小喙
function c65071056.initial_effect(c)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c65071056.tgcon)
	e2:SetTarget(c65071056.tgtg)
	e2:SetOperation(c65071056.tgop)
	c:RegisterEffect(e2)
end

function c65071056.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsControler(1-tp)
end
function c65071056.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65071056.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<6
end
function c65071056.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local num=g:GetCount()
	local nu=6-num
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,nu) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(nu)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,nu)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,0)
end
function c65071056.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local num=g:GetCount()
	local nu=6-num
	if Duel.Draw(1-tp,nu,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,0,nu,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
