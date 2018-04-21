--始源终焉龙 乌洛波洛斯
function c11113142.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11113142.sprcon)
	e2:SetOperation(c11113142.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--destroy & special summon parts
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11113142,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c11113142.descon)
	e4:SetTarget(c11113142.destg)
	e4:SetOperation(c11113142.desop)
	c:RegisterEffect(e4)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(c11113142.indtg)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e8)
end
function c11113142.matfilter(c)
	return c:GetSequence()>4
end
function c11113142.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c11113142.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local sg=Duel.GetMatchingGroup(c11113142.matfilter,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then	g:Merge(sg) end
	local ct=Duel.GetMatchingGroup(c11113142.ctfilter,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetLink)
	local rg=Duel.GetReleaseGroup(tp)
	return (g:GetCount()>0 or rg:GetCount()>0) and g:FilterCount(Card.IsReleasable,nil)==g:GetCount() and ct>9
end
function c11113142.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.SelectOption(tp,aux.Stringid(11113142,0))
	Duel.SelectOption(1-tp,aux.Stringid(11113142,0))
	local g=Duel.GetReleaseGroup(tp)
	local sg=Duel.GetMatchingGroup(c11113142.matfilter,tp,0,LOCATION_MZONE,nil):Filter(Card.IsReleasable,nil)
	if sg:GetCount()>0 then g:Merge(sg) end
	Duel.Release(g,REASON_COST)
end
function c11113142.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4
end
function c11113142.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lg=e:GetHandler():GetLinkedGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,lg,lg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(c11113142.chlimit)
end
function c11113142.chlimit(e,ep,tp)
	return tp==ep
end
function c11113142.spfilter1(c,e,tp,zone1,zone2)
	return c:IsCode(11113144) and ((c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,tp,zone1) 
	    and Duel.IsExistingMatchingCard(c11113142.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone2))
		or (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,1-tp,zone2) 
	    and Duel.IsExistingMatchingCard(c11113142.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone1)))
end
function c11113142.spfilter2(c,e,tp,zone)
	return c:IsCode(11113143) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,1-tp,zone)
end
function c11113142.spfilter3(c,e,tp,zone)
	return c:IsCode(11113143) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,tp,zone)
end

function c11113142.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    local lg=c:GetLinkedGroup()
	if lg:GetCount()>0 then Duel.Destroy(lg,REASON_EFFECT) end
	local seq=c:GetSequence()
	if seq<=4 or Duel.GetLocationCountFromEx(tp)<=0 or Duel.GetLocationCountFromEx(1-tp)<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local zone1=c:GetLinkedZone(tp)
	local zone2=c:GetLinkedZone(1-tp)
	if Duel.IsExistingMatchingCard(c11113142.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone1,zone2) then 
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc1=Duel.SelectMatchingCard(tp,c11113142.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone1,zone2):GetFirst()
	    if tc1 and tc1:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,tp,zone1)
	        and (not tc1:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,1-tp,zone2) or Duel.SelectYesNo(tp,aux.Stringid(11113142,2))) then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		    local tc2=Duel.SelectMatchingCard(tp,c11113142.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone2):GetFirst()
	        Duel.SpecialSummonStep(tc1,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,zone1)
		    Duel.SpecialSummonStep(tc2,SUMMON_TYPE_LINK,tp,1-tp,false,false,POS_FACEUP,zone2)
		    Duel.SpecialSummonComplete() 
	    else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		    local tc2=Duel.SelectMatchingCard(tp,c11113142.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone1):GetFirst()
            Duel.SpecialSummonStep(tc1,SUMMON_TYPE_LINK,tp,1-tp,false,false,POS_FACEUP,zone2)
	        Duel.SpecialSummonStep(tc2,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,zone1)
		    Duel.SpecialSummonComplete() 	
		end	
    end
end
function c11113142.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0 and c:IsSetCard(0x15d) and c:IsType(TYPE_LINK)
end