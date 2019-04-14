--美神 欧罗巴
function c47501112.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,3,c47501112.lcheck)  
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,47501112)
	e2:SetCondition(c47501112.spcon)
	e2:SetOperation(c47501112.spop)
	c:RegisterEffect(e2)  
	--spsummon bgm
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c47501112.sumsuc)
	c:RegisterEffect(e3)   
end
function c47501112.lcheck(g)
	return g:GetClassCount(Card.GetSummonType)==g:GetCount()
end
function c47501112.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47501112.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
end
function c47501112.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c47501112.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local tg=g:RandomSelect(tp,2)
	if #tg>0 then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)	
	end
end
function c47501112.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(47501112,0))
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(47501112,1))
end 