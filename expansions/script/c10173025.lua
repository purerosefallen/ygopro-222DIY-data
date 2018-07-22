--骑装火狮
function c10173025.initial_effect(c)
	c:SetSPSummonOnce(10173025)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10173025.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10173025.sprcon)
	e2:SetOperation(c10173025.sprop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173025,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c10173025.sptg)
	e3:SetOperation(c10173025.spop)
	c:RegisterEffect(e3)
end
function c10173025.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c10173025.sprfilter(c,fc)
	return c:IsRace(RACE_BEAST) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost() and not c:IsHasEffect(6205579)
end
function c10173025.sprfilter1(c,tp,g)
	return g:IsExists(c10173025.sprfilter2,1,c,tp,c)
end
function c10173025.sprfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c10173025.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10173025.sprfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(c10173025.sprfilter1,1,nil,tp,g)
end
function c10173025.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10173025.sprfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c10173025.sprfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c10173025.sprfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c10173025.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c10173025.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10173025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10173025.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_DISABLE)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   tc:RegisterEffect(e1,true)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_DISABLE_EFFECT)
		   e2:SetReset(RESET_EVENT+0x1fe0000)
		   tc:RegisterEffect(e2,true)
		   if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10173025,1)) then 
		   return end
		   Duel.BreakEffect()
		   if not Duel.Equip(tp,c,tc) then return end
		   local e3=Effect.CreateEffect(c)
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_EQUIP_LIMIT)
		   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e3:SetValue(c10173025.eqlimit)
		   e3:SetLabelObject(tc)
		   e3:SetReset(RESET_EVENT+0x1fe0000)
		   c:RegisterEffect(e3)
		   local e4=Effect.CreateEffect(c)
		   e4:SetType(EFFECT_TYPE_EQUIP)
		   e4:SetCode(EFFECT_UPDATE_ATTACK)
		   e4:SetValue(2500)
		   e4:SetReset(RESET_EVENT+0x1fe0000)
		   c:RegisterEffect(e4)
		end
	end
end
function c10173025.eqlimit(e,c)
	return c==e:GetLabelObject()
end