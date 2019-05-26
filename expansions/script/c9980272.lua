--吸血姬·公主
function c9980272.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9980272.ffilter,5,true)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c9980272.splimit)
	c:RegisterEffect(e2)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9980272.sprcon)
	e2:SetOperation(c9980272.sprop)
	c:RegisterEffect(e2)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--destroy and multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980272,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9980272.descon1)
	e2:SetTarget(c9980272.destg)
	e2:SetOperation(c9980272.desop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCondition(c9980272.descon2)
	c:RegisterEffect(e5)
	--cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,0xa)
	e1:SetTarget(c9980272.distg)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c9980272.distg)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c9980272.disop)
	c:RegisterEffect(e3)
	--disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c9980272.distg)
	c:RegisterEffect(e4)
end
function c9980272.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c9980272.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_MONSTER) and c:IsFusionSetCard(0xbc2) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c9980272.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9980272.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp,c)
end
function c9980272.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c9980272.sprfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,c)
end
function c9980272.sprfilter2(c,tp,fc,mc1)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionCode(mc1:GetFusionCode())
		and Duel.IsExistingMatchingCard(c9980272.sprfilter3,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,mc1,c)
end
function c9980272.sprfilter3(c,tp,fc,mc1,mc2)
	local g=Group.FromCards(c,mc1,mc2)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionCode(mc1:GetFusionCode()) and not c:IsFusionCode(mc2:GetFusionCode())
		and Duel.IsExistingMatchingCard(c9980272.sprfilter4,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,mc1,mc2,c)
end
function c9980272.sprfilter4(c,tp,fc,mc1,mc2,mc3)
	local g=Group.FromCards(c,mc1,mc2,mc3)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionCode(mc1:GetFusionCode()) and not c:IsFusionCode(mc2:GetFusionCode()) and not c:IsFusionCode(mc3:GetFusionCode())
		and Duel.IsExistingMatchingCard(c9980272.sprfilter5,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,mc1,mc2,mc3,c)
end
function c9980272.sprfilter5(c,tp,fc,mc1,mc2,mc3,mc4)
	local g=Group.FromCards(c,mc1,mc2,mc3,mc4)
	return c:IsFusionSetCard(0xbc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionCode(mc1:GetFusionCode()) and not c:IsFusionCode(mc2:GetFusionCode()) and not c:IsFusionCode(mc3:GetFusionCode()) and not c:IsFusionCode(mc4:GetFusionCode())
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c9980272.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c9980272.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c9980272.sprfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c9980272.sprfilter3,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst())
	local g4=Duel.SelectMatchingCard(tp,c9980272.sprfilter4,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst(),g3:GetFirst())
	local g5=Duel.SelectMatchingCard(tp,c9980272.sprfilter5,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst(),g3:GetFirst(),g4:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	g1:Merge(g5)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c9980272.distg(e,c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c9980272.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and ep~=tp and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end
function c9980272.descon1(ce,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c9980272.descon2(ce,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c9980272.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9980272.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end