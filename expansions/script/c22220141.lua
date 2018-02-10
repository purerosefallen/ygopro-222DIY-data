--永远与须臾的白沢球
function c22220141.initial_effect(c)
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
	e2:SetCondition(c22220141.sprcon)
	e2:SetOperation(c22220141.sprop)
	c:RegisterEffect(e2)
	--synchro custom
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(c22220141.syntg)
	e3:SetOperation(c22220141.synop)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--synchro limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c22220141.synlimit)
	c:RegisterEffect(e4)
	--TYPE_SPIRIT
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c22220141.top)
	c:RegisterEffect(e5)
end
function c22220141.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x50f)
end
function c22220141.sprfilter(c)
	return c:IsSetCard(0x50f) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c22220141.sprfilter1(c,tp,g,sc)
	return c:IsType(TYPE_TUNER) and g:IsExists(c22220141.sprfilter2,1,c,tp,c,sc)
end
function c22220141.sprfilter2(c,tp,mc,sc)
	local sg=Group.FromCards(c,mc)
	return not c:IsType(TYPE_TUNER) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c22220141.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c22220141.sprfilter,tp,LOCATION_HAND,0,nil)
	return g:IsExists(c22220141.sprfilter1,1,nil,tp,g,c)
end
function c22220141.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c22220141.sprfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c22220141.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c22220141.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c22220141.synfilter(c,syncard,tuner,f)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or (c:IsSetCard(0x50f) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND))) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c22220141.matfilter(c,flag)
	if flag and Duel.GetLocationCountFromEx(tp,tp,c) < 1 then return false end
	return true
end
function c22220141.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	if lv~=c:GetLevel() then return false end
	local tp=c:GetControler()
	local flag=Duel.GetLocationCountFromEx(tp,tp,c)<1
	local mg=Duel.GetMatchingGroup(c22220141.synfilter,syncard:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,c,syncard,c,f)
	return mg:IsExists(c22220141.matfilter,1,c,flag)
end
function c22220141.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	if lv~=c:GetLevel() then return false end
	local g=Duel.GetMatchingGroup(c22220141.synfilter,syncard:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local flag=Duel.GetLocationCountFromEx(tp,tp,c)<1
	local fmat=g:FilterSelect(tp,c22220141.matfilter,1,1,c,flag):GetFirst()
	local mg=Group.FromCards(fmat)
	g:RemoveCard(fmat)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22220141,0)) then
		local temp=g:Select(tp,1,99,nil)
		mg:Merge(temp)
	end
	Duel.SetSynchroMaterial(mg)
end
function c22220141.top(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,22220141)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c22220141.tyg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(TYPE_SPIRIT)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,22220141,RESET_PHASE+PHASE_END,0,1)
end
function c22220141.tyg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x50f)
end