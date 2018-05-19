--水歌 幼奏的科丝特
local m=12003018
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(0)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
--
function cm.filter3(c,e,tp,tc)
	local g=Group.CreateGroup()
	g:AddCard(c)
	g:AddCard(tc)
	return c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_MONSTER) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,g)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,tc)
end
function cm.spfilter(c,e,tp,tc,sc)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==(tc:GetLevel()+sc:GetLevel()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,c) and c:IsReleasable()
	end
	e:SetLabel(0)
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,c)
	local tc=g:GetFirst()
	g:AddCard(c)
	local num=tc:GetLevel()+c:GetLevel()
	Duel.Release(g,REASON_COST)
	e:SetLabel(num)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function cm.spfilter2(c,e,tp,num)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_SEASERPENT) and c:GetLevel()==num and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,num)
	local tc=tg:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ATTRIBUTE_WATER)
		tc:RegisterEffect(e1)
	end
	e:SetLabel(0)
end
--
function cm.thfilter(c)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0xfb8))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
