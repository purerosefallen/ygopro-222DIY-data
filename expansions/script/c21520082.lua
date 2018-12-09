--空间感应者
function c21520082.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c21520082.fsfilter1,c21520082.fsfilter2,1,99,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520082.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCondition(c21520082.sprcon)
	e00:SetOperation(c21520082.sprop)
	e00:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e00)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c21520082.matcheck)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c21520082.sdcon)
	c:RegisterEffect(e2)
	--to deck and power up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520082,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c21520082.cost)
	e3:SetTarget(c21520082.tg)
	e3:SetOperation(c21520082.op)
	c:RegisterEffect(e3)
end
c21520082.miracle_synchro_fusion=true
function c21520082.fsfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(6) and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c21520082.fsfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c21520082.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler()
end
function c21520082.cfilter(c,tp)
	return ((c:IsLevelAbove(6) and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)) or c:IsRace(RACE_SPELLCASTER)) 
		and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup())
end
function c21520082.fcheck(c,sg)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(6) and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER)
		and c:IsType(TYPE_MONSTER) and sg:FilterCount(c21520082.fcheck2,c)+1==sg:GetCount()
end
function c21520082.fcheck2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
function c21520082.fgoal(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c21520082.fcheck,1,nil,sg)
end
function c21520082.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c21520082.fgoal(c,tp,sg) or mg:IsExists(c21520082.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c21520082.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520082.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520082.fselect,1,nil,tp,mg,sg)
end
function c21520082.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21520082.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c21520082.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c21520082.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_MATERIAL+REASON_FUSION)

--	c:RegisterFlagEffect(21520082,RESET_EVENT+0xfc0000,0,1)
end
function c21520082.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_SET_BASE_ATTACK)
	ae:SetValue(ct*500)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520082.sdcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION --and e:GetHandler():GetFlagEffect(21520082)==0
end
function c21520082.rfliter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL)
end
function c21520082.tdfliter(c)
	return c:IsAbleToDeck() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_LEAVE_CONFIRMED)
end
function c21520082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520082.rfliter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520082.rfliter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520082.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,0,1000)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,nil,0,0,1000)
end
function c21520082.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		if not tc:IsImmuneToEffect(e) then
			local op=Duel.SelectOption(tp,aux.Stringid(21520082,1),aux.Stringid(21520082,2))
			Duel.SendtoDeck(tc,nil,op,REASON_EFFECT)
		end
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetCode(EFFECT_UPDATE_ATTACK)
		ae:SetValue(1000)
		ae:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(ae)
		local de=ae:Clone()
		de:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(de)
	end
end
