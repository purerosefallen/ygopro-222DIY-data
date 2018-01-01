--链接设计者
function c22270161.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),1,1)
	--change link arrow
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270161,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,222701611)
	e1:SetTarget(c22270161.tg)
	e1:SetOperation(c22270161.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22270161,9))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,222701612)
	e2:SetTarget(c22270161.sptg)
	e2:SetOperation(c22270161.spop)
	c:RegisterEffect(e2)
end
c22270161.named_with_ShouMetsu_ToShi=1
function c22270161.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270161.cfilter(c)
	return c:IsType(TYPE_LINK) and c:GetLink()==1
end
function c22270161.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c22270161.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22270161.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c22270161.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local la=Duel.SelectOption(tp,aux.Stringid(22270161,0),aux.Stringid(22270161,1),aux.Stringid(22270161,2),aux.Stringid(22270161,3),aux.Stringid(22270161,4),aux.Stringid(22270161,5),aux.Stringid(22270161,6),aux.Stringid(22270161,7))
	local lm=0
	if la==0 then lm=0x040
	elseif la==1 then lm=0x080
	elseif la==2 then lm=0x100
	elseif la==3 then lm=0x020
	elseif la==4 then lm=0x004
	elseif la==5 then lm=0x002
	elseif la==6 then lm=0x001
	elseif la==7 then lm=0x008
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(lm)
	tc:RegisterEffect(e1,true)
end
function c22270161.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22270161.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetMutualLinkedGroup()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c22270161.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22270161.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMutualLinkedGroup()
	if g:GetCount()<1 then return end
	if Duel.Destroy(g,REASON_EFFECT)<1 then return end
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22270161.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end