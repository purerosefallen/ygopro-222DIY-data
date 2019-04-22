--战场女武神 塞露贝利亚 瓦尔基里
function c11113004.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11113013,aux.FilterBoolFunction(Card.IsFusionSetCard,0x15c),1,true,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11113004.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11113004.sprcon)
	e2:SetOperation(c11113004.sprop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113004,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11113004)
	e3:SetCondition(c11113004.negcon)
	e3:SetCost(c11113004.negcost)
	e3:SetTarget(c11113004.negtg)
	e3:SetOperation(c11113004.negop)
	c:RegisterEffect(e3)
	--index
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11113004,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,111130040)
	e4:SetCost(c11113004.indcost)
	e4:SetTarget(c11113004.indtg)
	e4:SetOperation(c11113004.indop)
	c:RegisterEffect(e4)
end
function c11113004.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c11113004.cfilter(c)
	return (c:IsFusionCode(11113013) or c:IsFusionSetCard(0x15c) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c11113004.spfilter1(c,tp,g)
	return g:IsExists(c11113004.spfilter2,1,c,tp,c)
end
function c11113004.spfilter2(c,tp,mc)
	return (c:IsFusionCode(11113013) and mc:IsFusionSetCard(0x15c) and mc:IsType(TYPE_MONSTER)
		or c:IsFusionSetCard(0x15c) and c:IsType(TYPE_MONSTER) and mc:IsFusionCode(11113013))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c11113004.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11113004.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c11113004.spfilter1,1,nil,tp,g)
end
function c11113004.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c11113004.cfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c11113004.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c11113004.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c11113004.negcon(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c11113004.dfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsAbleToDeckOrExtraAsCost()
end	
function c11113004.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113004.dfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11113004.dfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c11113004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11113004.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11113004.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113004.infilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsType(TYPE_FUSION)
end
function c11113004.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11113004.infilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11113004.infilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11113004.infilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11113004.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c11113004.efilter)
		tc:RegisterEffect(e1)
	end
end
function c11113004.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and (te:IsHasType(0x7e0) or te:IsHasProperty(EFFECT_FLAG_FIELD_ONLY) or te:IsHasProperty(EFFECT_FLAG_OWNER_RELATE)) then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	end
	return false
end