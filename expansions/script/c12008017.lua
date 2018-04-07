--汇聚的新神，波恋达斯
function c12008017.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c12008017.lcheck)
	c:EnableReviveLimit()
	--CANNOT ACTIVATE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c12008017.tgcon)
	e1:SetValue(c12008017.aclimit)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008017,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c12008017.rmcost)
	e2:SetTarget(c12008017.rmtg)
	e2:SetOperation(c12008017.rmop)
	c:RegisterEffect(e2)
end
function c12008017.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c12008017.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c12008017.tgcon(e)
	return Duel.GetCurrentPhase()~=PHASE_MAIN2 and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c12008017.thfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c12008017.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008017.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12008017.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsSetCard(0x1fb3) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12008017.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c12008017.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12008017,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
end
