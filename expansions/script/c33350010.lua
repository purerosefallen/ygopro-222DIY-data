--传说之魂 英勇
function c33350010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33350010.xyzfilter,1,3)
	c:EnableReviveLimit() 
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33350010,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33350010.macon)
	e1:SetTarget(c33350010.matg)
	e1:SetOperation(c33350010.maop)
	c:RegisterEffect(e1)  
	--negate
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(33350010,4))
	e11:SetCategory(CATEGORY_NEGATE+CATEGORY_POSITION)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetCountLimit(1)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCost(c33350010.discost)
	e11:SetCondition(c33350010.discon)
	e11:SetTarget(c33350010.distg)
	e11:SetOperation(c33350010.disop)
	c:RegisterEffect(e11) 
end
c33350010.setname="TaleSouls"
function c33350010.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33350010.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_MZONE)~=0
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c33350010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33350010.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() then
		Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
	end
end
function c33350010.xyzfilter(c)
	return c.setname=="TaleSouls"
end
function c33350010.ccfilter(c,tp)
	return c:IsControler(tp) or (c:IsAbleToChangeControler() and c:IsControler(1-tp) and c:IsOnField()) or not c:IsOnField()
end
function c33350010.macon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,33350018)
end
function c33350010.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33350010.ccfilter,tp,0,0x1e,1,c,tp) end
end
function c33350010.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g1=Duel.GetMatchingGroup(c33350010.ccfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c33350010.ccfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	local g3=Duel.GetMatchingGroup(c33350010.ccfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,tp)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(33350010,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(33350010,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(33350010,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.HintSelection(sg3)
		sg:Merge(sg3)
	end
	local og=sg:Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	if og:GetCount()>0 then
	   Duel.Overlay(c,og)
	end
end