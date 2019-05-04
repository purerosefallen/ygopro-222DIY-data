--高达试作4号机
function c47530048.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c47530048.psplimit)
	c:RegisterEffect(e0)   
	--xyz change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47530048,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,47530048)
	e1:SetTarget(c47530048.sptg)
	e1:SetOperation(c47530048.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47530048,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e2:SetCountLimit(1,47530049)
	e2:SetCondition(c47530048.spcon)
	e2:SetValue(c47530048.spval)
	c:RegisterEffect(e2)
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47530048,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c47530048.desop)
	c:RegisterEffect(e3)
end
function c47530048.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE)
end
function c47530048.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530048.dafilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c47530048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c47530048.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c47530048.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c47530048.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lg=tc:GetOverlayGroup()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=lg:FilterSelect(tp,c47530048.filter,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c47530048.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c47530048.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c47530048.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if cg:GetCount()>0 then
		Duel.Destroy(cg,REASON_EFFECT)
	end
end