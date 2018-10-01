--跳跳兔
function c11200100.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.TRUE,c11200100.xyzcheck,2,2) 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200100,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11200100.atkcost)
	e1:SetOperation(c11200100.atkop)
	c:RegisterEffect(e1)   
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(11200100,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,11200100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11200100.spcon)
	e2:SetTarget(c11200100.sptg)
	e2:SetOperation(c11200100.spop)
	c:RegisterEffect(e2) 
end
function c11200100.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()<=0
end
function c11200100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c11200100.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and c:IsAbleToRemove() and Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_GRAVE,0)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c11200100.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<=0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c11200100.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and not tc:IsImmuneToEffect(e) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	   local xg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11200100.xfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,2,nil,e) 
	   if xg:GetCount()>0 then
		  Duel.BreakEffect()
		  Duel.Overlay(tc,xg)
	   end
	end
end
function c11200100.xfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c11200100.spfilter(c,e,tp)
	return c:IsCode(11200100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200100.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c11200100.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11200100.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,11200100))
	e1:SetLabel(c:GetBaseAttack())
	e1:SetValue(c11200100.atkval)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetLabel(c:GetBaseDefense())
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c11200100.atkval(e,c)
	return e:GetLabel()+500
end