--Wings·成宫由爱
function c81013019.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,81013000,c81013019.matfilter,1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81013019.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81013019,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c81013019.sprcon)
	e2:SetOperation(c81013019.sprop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81013019)
	e3:SetCondition(c81013019.spcon)
	e3:SetTarget(c81013019.sptg)
	e3:SetOperation(c81013019.spop)
	c:RegisterEffect(e3)
end
function c81013019.matfilter(c)
	return c:IsFusionType(TYPE_EFFECT) and c:IsFusionAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeckOrExtraAsCost()
end
function c81013019.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c81013019.cfilter(c)
	return (c:IsFusionCode(81013000) or c81013019.matfilter(c))
		and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c81013019.spfilter1(c,tp,g)
	return g:IsExists(c81013019.spfilter2,1,c,tp,c)
end
function c81013019.spfilter2(c,tp,mc)
	return (c:IsFusionCode(81013000) and c81013019.matfilter(c) and mc:IsType(TYPE_MONSTER)
		or c81013019.matfilter(c) and c:IsType(TYPE_MONSTER) and mc:IsFusionCode(81013000))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c81013019.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81013019.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c81013019.spfilter1,1,nil,tp,g)
end
function c81013019.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c81013019.cfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,c81013019.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:FilterSelect(tp,c81013019.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c81013019.spfilter(c,tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsCode(81013019)
end
function c81013019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81013019.spfilter,1,nil,tp)
end
function c81013019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81013019.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81013901,0,0x4011,0,0,3,RACE_SPELLCASTER,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,81013901)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end