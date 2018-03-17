--天选圣女 圣枪洁希德
local m=10120001
local cm=_G["c"..m]
if not RSDSVal then
   RSDSVal=RSDSVal or {}
   dsrsv=RSDSVal
   function dsrsv.DanceSpiritSpecialSummonRule(c,sprcon,sprop)
	   local e1=Effect.CreateEffect(c)
	   e1:SetCountLimit(1,code)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_SPSUMMON_PROC)
	   e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	   e1:SetRange(LOCATION_HAND)
	   if sprcon then
		  e1:SetCondition(sprcon)
	   end
	   if sprop then
		  e1:SetOperation(sprop)
	   end
	   c:RegisterEffect(e1)
	   if not dsrsv.DanceSpiritAdjust then
		  dsrsv.DanceSpiritAdjust=true
		  local g=Group.CreateGroup()
		  g:KeepAlive()
		  --adjust timing, try not rewrite system function
		  local ge1=Effect.CreateEffect(c)
		  ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  ge1:SetCode(EVENT_ADJUST)
		  ge1:SetOperation(dsrsv.sumop)
		  ge1:SetLabelObject(g)
		  Duel.RegisterEffect(ge1,0)
		  local ge2=ge1:Clone()
		  ge2:SetCode(EVENT_SPSUMMON)
		  ge2:SetOperation(dsrsv.sumop2)
		  Duel.RegisterEffect(ge2,0)
		  local ge3=ge1:Clone()
		  ge3:SetCode(EVENT_SUMMON)
		  ge3:SetOperation(dsrsv.sumop2)
		  Duel.RegisterEffect(ge3,0)   
		  local ge4=ge1:Clone()
		  ge4:SetCode(EVENT_CHAIN_NEGATED)
		  ge4:SetOperation(dsrsv.sumop3)
		  Duel.RegisterEffect(ge4,0) 
		  local ge5=ge1:Clone()
		  ge5:SetCode(EVENT_CHAIN_DISABLED)
		  ge5:SetOperation(dsrsv.sumop3)
		  --Duel.RegisterEffect(ge5,0) 
		  local ge6=ge1:Clone()
		  ge6:SetCode(EVENT_SPSUMMON_SUCCESS)
		  ge6:SetOperation(dsrsv.sumop4)
		  Duel.RegisterEffect(ge6,0) 
		  local ge7=ge1:Clone()
		  ge7:SetCode(EVENT_SUMMON_SUCCESS)
		  ge7:SetOperation(dsrsv.sumop4)
		  Duel.RegisterEffect(ge7,0) 
		  local ge8=ge1:Clone()
		  ge8:SetCode(EVENT_TO_HAND)
		  ge8:SetOperation(dsrsv.sumop5)
		  Duel.RegisterEffect(ge8,0)
		  local ge9=ge1:Clone()
		  ge9:SetCode(EVENT_TO_DECK)
		  ge9:SetOperation(dsrsv.sumop5)
		  Duel.RegisterEffect(ge9,0) 
		  local ge10=ge1:Clone()
		  ge10:SetCode(EVENT_CHAIN_SOLVED)
		  ge10:SetOperation(dsrsv.sumop6)
		  Duel.RegisterEffect(ge10,0) 
		  dissumg=Group.CreateGroup()
		  dissumg:KeepAlive()
	   end
   end
   function dsrsv.DanceSpiritSummonSucessEffect(c,code,cate,sstg,ssop,sscon)
	   local e2=Effect.CreateEffect(c)
	   e2:SetDescription(aux.Stringid(code,1))
	   if cate then
		  e2:SetCategory(cate)
	   end
	   e2:SetDescription(aux.Stringid(10120001,0))
	   e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	   e2:SetCode(EVENT_SUMMON_SUCCESS)
	   e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	   if sscon then
		  e2:SetCondition(sscon)
	   end
	   if sstg then
		  e2:SetTarget(sstg)
	   end
	   e2:SetOperation(ssop)
	   c:RegisterEffect(e2)
	   local e3=e2:Clone()
	   e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	   c:RegisterEffect(e3) 
   end
   function dsrsv.DanceSpiritNegateEffect(c,code,cate,ntg,nop,flag)
	   local e4=Effect.CreateEffect(c)
	   e4:SetDescription(aux.Stringid(code,2))
	   if cate then
		  e4:SetCategory(cate)
	   end
	   if flag then
		  e4:SetProperty(flag)
	   end
	   e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	   e4:SetCode(EVENT_CUSTOM+m)
	   e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	   e4:SetTarget(ntg)
	   e4:SetOperation(nop)
	   c:RegisterEffect(e4)
   end
   function dsrsv.sumop6(e,tp,eg,ep,ev,re,r,rp)
	   local dis=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON)
	   if dis then
		  Duel.RaiseSingleEvent(re:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
	   end
   end
   function dsrsv.sumop5(e,tp,eg,ep,ev,re,r,rp)
	   for tc in aux.Next(eg) do
		   if tc and not tc:IsPreviousLocation(0xff) and dissumg:IsContains(tc) then
			  Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+m,e,0,0,0,0)
			  dissumg:RemoveCard(tc)
		   end
	   end
   end
   function dsrsv.sumop2(e,tp,eg,ep,ev,re,r,rp)
	   local g=e:GetLabelObject()
	   for tc in aux.Next(eg) do
		   if (not tc:IsType(TYPE_SYNCHRO) or tc:IsSummonType(SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_LINK)) and not tc:IsCode(10120010) then
			  g:AddCard(tc)
		   end
	   end
   end
   function dsrsv.sumop(e,tp,eg,ep,ev,re,r,rp)
	   local g=e:GetLabelObject()
	   if g:GetCount()<=0 then return end
	   for tc in aux.Next(g) do
		  if not tc:IsLocation(LOCATION_MZONE) then
			 dissumg:AddCard(tc)
			 Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+m,e,0,0,0,0)
			 Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			 Duel.RegisterFlagEffect(tc:GetControler(),m+500,RESET_PHASE+PHASE_END,0,1)
			 g:RemoveCard(tc)
		  end
	   end
   end
   function dsrsv.sumop3(e,tp,eg,ep,ev,re,r,rp)
	   Duel.RaiseSingleEvent(re:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
	   Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
	   Duel.RegisterFlagEffect(re:GetHandler():GetControler(),m+500,RESET_PHASE+PHASE_END,0,1)
   end
   function dsrsv.sumop4(e,tp,eg,ep,ev,re,r,rp)
	   local g=e:GetLabelObject()
	   for tc in aux.Next(eg) do
		   if g:IsContains(tc) then
			  g:RemoveCard(tc)
		   end
	   end
	   for tc in aux.Next(dissumg) do
		   if dissumg:IsContains(tc) then
			  dissumg:RemoveCard(tc)
		   end
	   end
   end
end
if cm then
function cm.initial_effect(c)
	dsrsv.DanceSpiritSpecialSummonRule(c,cm.sprcon,cm.sprop) 
	dsrsv.DanceSpiritSummonSucessEffect(c,m,CATEGORY_SEARCH+CATEGORY_TOHAND,cm.sstg,cm.ssop)   
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_SPECIAL_SUMMON,cm.ntg,cm.nop)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9331) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,cm.cfilter,1,c,tp)
end
function cm.cfilter(c,tp)
	return c:IsSetCard(0x9331) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroupEx(tp,cm.cfilter,1,1,c,tp)
	Duel.Release(g,REASON_COST)
end



end