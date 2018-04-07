--永世的束缚，波恋达斯
function c12008012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1fb3),4,2)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetDescription(aux.Stringid(12008012,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c12008012.condition)
	e1:SetTarget(c12008012.target)
	e1:SetOperation(c12008012.operation)
	c:RegisterEffect(e1) 
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008012,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c12008012.mvcost)
	e2:SetTarget(c12008012.mvtg)
	e2:SetOperation(c12008012.mvop)
	c:RegisterEffect(e2)   
end
function c12008012.filter(c)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,c:GetControler(),LOCATION_REASON_CONTROL)>0 
end
function c12008012.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c12008012.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c12008012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c12008012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetFirst():IsControler(1-tp) then
	   e:SetLabel(100)
	else
	   e:SetLabel(0)
	end
end
function c12008012.rfilter(c)
	return c:IsAttackAbove(2500) and c:IsAbleToRemove()
end
function c12008012.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c12008012.rfilter,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil)
	if e:GetLabel()==100 and g:GetCount()>=2 and Duel.IsChainDisablable(0) and Duel.SelectYesNo(1-tp,aux.Stringid(12008012,2)) then
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	   local sg=g:Select(1-tp,2,2,nil)
	   Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	   Duel.NegateEffect(0)
	   return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=0
	if tc:IsControler(tp) then
	   s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	else
	   s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)/0x10000
	end
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c12008012.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
end
function c12008012.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12008012.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c12008012.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rc~=e:GetHandler() and rc:IsRelateToEffect(re) and (rc:IsControler(tp) or rc:IsAbleToChangeControler())
end
function c12008012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,0,0,rp,0)
end
function c12008012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) and not rc:IsImmuneToEffect(e) then
	   local tf=false
	   if rc:IsType(TYPE_MONSTER) then tf=true end
	   local og=rc:GetOverlayGroup()
	   if og:GetCount()>0 then
		  Duel.SendtoGrave(og,REASON_RULE)
	   end
	   Duel.Overlay(c,Group.FromCards(rc))
	   local sg=Duel.GetMatchingGroup(Card.IsSummonable,rp,LOCATION_HAND,0,nil,true,nil)
	   if sg:GetCount()>0 and tf and Duel.SelectYesNo(rp,aux.Stringid(12008012,3)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_SUMMON)
		  local tc=sg:Select(rp,1,1,nil):GetFirst()
		  Duel.Summon(rp,tc,true,nil)
	   end
	end
end

