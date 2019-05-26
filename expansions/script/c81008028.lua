--圣夜的祝宴·高垣枫
function c81008028.initial_effect(c)
	c:SetSPSummonOnce(81008028)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c81008028.ovfilter,aux.Stringid(81008028,0))
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81008028,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81008028)
	e1:SetCondition(c81008028.chcon)
	e1:SetCost(c81008028.chcost)
	e1:SetTarget(c81008028.chtg)
	e1:SetOperation(c81008028.chop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81008928)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81008028.tdtg)
	e2:SetOperation(c81008028.tdop)
	c:RegisterEffect(e2)
end
function c81008028.ovfilter(c)
	return c:IsFaceup() and c:IsCode(81009011)
end
function c81008028.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and (rc:GetType()==TYPE_SPELL or rc:GetType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c81008028.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81008028.thfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c81008028.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81008028.thfilter,rp,0,LOCATION_REMOVED,1,nil) end
end
function c81008028.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c81008028.repop)
end
function c81008028.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c81008028.thfilter,tp,0,LOCATION_REMOVED,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c81008028.tdfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end
function c81008028.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c81008028.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81008028.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81008028.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
end
function c81008028.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
