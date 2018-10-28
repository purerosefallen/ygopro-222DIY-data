--Wings·三船美优
function c81013010.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,81013000,c81013010.matfilter,1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81013010.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81013010,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c81013010.sprcon)
	e2:SetOperation(c81013010.sprop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c81013010.damcon)
	e3:SetTarget(c81013010.damtg)
	e3:SetOperation(c81013010.damop)
	c:RegisterEffect(e3)
end
function c81013010.matfilter(c)
	return c:IsFusionType(TYPE_LINK) and c:IsFusionType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c81013010.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c81013010.cfilter(c)
	return (c:IsFusionCode(81013000) or c81013010.matfilter(c))
		and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c81013010.spfilter1(c,tp,g)
	return g:IsExists(c81013010.spfilter2,1,c,tp,c)
end
function c81013010.spfilter2(c,tp,mc)
	return (c:IsFusionCode(81013000) and c81013010.matfilter(c) and mc:IsType(TYPE_MONSTER)
		or c81013010.matfilter(c) and c:IsType(TYPE_MONSTER) and mc:IsFusionCode(81013000))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c81013010.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81013010.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c81013010.spfilter1,1,nil,tp,g)
end
function c81013010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c81013010.cfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,c81013010.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:FilterSelect(tp,c81013010.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c81013010.sscon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:GetReasonCard()==e:GetHandler()
		and tc:IsReason(REASON_BATTLE) 
end
function c81013010.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bit.band(bc:GetType(),TYPE_LINK)~=0
end
function c81013010.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local m=0
	if a==e:GetHandler() then m=d:GetLink()*500
	else m=a:GetLink()*500 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(m)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,m)
end
function c81013010.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
