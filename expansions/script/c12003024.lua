--水歌 夏大三角 幻奏的奇美
function c12003024.initial_effect(c)
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
	e2:SetCondition(c12003024.sprcon)
	e2:SetOperation(c12003024.sprop)
	c:RegisterEffect(e2)	
	--mat
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12003024,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c12003024.mattg)
	e3:SetOperation(c12003024.matop)
	c:RegisterEffect(e3)
	--material2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12003024,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_DAMAGE_STEP)
	e4:SetCost(c12003024.macost)
	e4:SetOperation(c12003024.maop)
	c:RegisterEffect(e4)
end
function c12003024.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,3,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c12003024.maop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,ct=e:GetHandler(),e:GetLabel()
	if c:IsRelateToEffect(e) and ct>=1 and c:IsFaceup() then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	   e1:SetValue(1) 
	   e1:SetReset(RESET_EVENT+0x1ff0000)
	   c:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_IMMUNE_EFFECT)
	   e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e2:SetReset(RESET_EVENT+0x1ff0000)
	   e2:SetRange(LOCATION_MZONE)
	   e2:SetValue(c12003024.efilter)
	   c:RegisterEffect(e2)
	end
	if c:IsRelateToEffect(e) and ct>=2 and c:IsFaceup() then
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	   e3:SetCode(EVENT_BATTLE_CONFIRM)
	   e3:SetOperation(c12003024.tdop)
	   c:RegisterEffect(e3)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x4,nil)
	if ct>=3 and g:GetCount()>0 and Duel.SelectEffectYesNo(tp,c) then
	   local pg=g:Filter(Card.IsCanTurnSet,nil) 
	   if pg:GetCount()>0 then 
		  Duel.ChangePosition(pg,POS_FACEDOWN_DEFENSE)
		  g:Sub(pg)
	   end
	   if g:GetCount()>0 then
		  Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	   end
	end
end
function c12003024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
	   Duel.Hint(HINT_CARD,0,12003024)
	   Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c12003024.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false
	end
	return true
end
function c12003024.matfilter(c)
	return c:IsRace(RACE_SEASERPENT)
end
function c12003024.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12003024.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c12003024.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c12003024.matfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	   local og=g:Select(tp,1,3,nil)
	   Duel.Overlay(c,og)
	end
end
function c12003024.spfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial() and c:IsFaceup() and c:IsSetCard(0x9fb8) and c:IsType(TYPE_MONSTER)
end
function c12003024.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c12003024.fselect,1,sg,tp,mg,sg)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
	sg:RemoveCard(c)
	return res
end
function c12003024.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c12003024.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c12003024.fselect,1,nil,tp,mg,sg)
end
function c12003024.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c12003024.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c12003024.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
