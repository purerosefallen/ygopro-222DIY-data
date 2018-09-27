--夜鸦·TGS-Ⅰ
local m=10114001
local cm=_G["c"..m]
if not RSNRVal then
   RSNRVal=RSNRVal or {}
   nrrsv=RSNRVal
   function nrrsv.NightRavenSpecialSummonRule(c,lv,mcode)
	   local code=c:GetOriginalCodeRule()
	   local e1=Effect.CreateEffect(c)
	   e1:SetDescription(aux.Stringid(m,0))
	   e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	   e1:SetType(EFFECT_TYPE_QUICK_O)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetCountLimit(1,code)
	   e1:SetCode(EVENT_FREE_CHAIN)
	   e1:SetHintTiming(0,0x1e0)
	   e1:SetCondition(nrrsv.NRspcon)
	   e1:SetCost(nrrsv.NRspcost)
	   e1:SetLabel(lv)
	   e1:SetTarget(nrrsv.NRsptg)
	   e1:SetOperation(nrrsv.NRspop)
	   c:RegisterEffect(e1) 
	   if mcode then
		  e1:SetValue(mcode)
		  local e0=Effect.CreateEffect(c)
		  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e0:SetCode(EVENT_SPSUMMON_SUCCESS)
		  e0:SetLabel(mcode)
		  e0:SetOperation(nrrsv.regop)
		  c:RegisterEffect(e0)
	   end
   end
   function nrrsv.NightRavenSpecialSummonEffect(c,cate,tg,op)
	   local code=c:GetOriginalCodeRule()
	   local e2=Effect.CreateEffect(c)
	   e2:SetDescription(aux.Stringid(code,1))
	   if cate then
		  e2:SetCategory(cate)
	   end
	   e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	   e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	   e2:SetCountLimit(1,code)
	   e2:SetCondition(nrrsv.NRcon)
	   e2:SetCost(nrrsv.NRcost2)
	   if tg then
		  e2:SetTarget(tg)
	   end
	   e2:SetOperation(op)
	   c:RegisterEffect(e2)
	   local ccode=_G["c"..code]
	   ccode.NightRavenSpecialSummonEffect=e2
   end
end
function nrrsv.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(e:GetLabel(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function nrrsv.NRcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function nrrsv.NRcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x3331)
end
function nrrsv.NRspcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetValue() or e:GetHandler():GetFlagEffect(e:GetValue())==0
end
function nrrsv.NRspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function nrrsv.NRsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(nrrsv.NRspfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetLabel(),c:GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function nrrsv.NRspfilter(c,e,tp,lv,code)
	return c:IsSetCard(0x3331) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLevelBelow(lv) and lv<=7) or (lv==8 and c:IsLevelBelow(7)))
end
function nrrsv.NRspop(e,tp,eg,ep,ev,re,r,rp)
	local c,lv,ft,g=e:GetHandler(),e:GetLabel(),Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if lv==8 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsExistingMatchingCard(nrrsv.NRspfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp,4,c:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
	   g=Duel.SelectMatchingCard(tp,nrrsv.NRspfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil,e,tp,4,c:GetCode())
	else
	   g=Duel.SelectMatchingCard(tp,nrrsv.NRspfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,lv,c:GetCode())
	end
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
if cm then
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,5)
	nrrsv.NightRavenSpecialSummonEffect(c,CATEGORY_TOHAND+CATEGORY_SEARCH,cm.thtg,cm.thop)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x3331) and (c:IsAbleToHand() or ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable())))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local setable=((tc:IsType(TYPE_TRAP+TYPE_SPELL) and tc:IsSSetable()) or (tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
	if setable and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
	   if tc:IsType(TYPE_MONSTER) then
		  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	   else
		  Duel.SSet(tp,tc)
	   end
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	Duel.ConfirmCards(1-tp,tc)
end
end